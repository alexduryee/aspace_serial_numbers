class Sequence

  def self.get(sequence)
    DB.open(true) do |db|

      Thread.current[:initialised_sequences] ||= {}

      if !Thread.current[:initialised_sequences][sequence]
        Thread.current[:initialised_sequences][sequence] = true

        DB.attempt {

          if sequence.eql?("component_mss_id")
            init(sequence, 3000000)
            return 3000000
          else
            init(sequence, 0)
            return 0
          end

        }.and_if_constraint_fails {
          # Sequence is already defined, which is fine
        }
      end

      # If we make it to here, the sequence already exists and needs to be incremented
      1000.times do
        old_value = db[:sequence].filter(:sequence_name => sequence.to_s).get(:value)
        updated_count = db[:sequence].filter(:sequence_name => sequence.to_s, :value => old_value).
                                      update(:value => old_value + 1)

        if updated_count == 0
          # Need to retry
          sleep(0.01)
        elsif updated_count == 1
          return old_value + 1
        else
          raise SequenceError.new("Unrecognised response from SQL update when generating next element in sequence '#{sequence}': #{updated_count}")
        end
      end

      raise SequenceError.new("Gave up trying to generate a sequence number for: '#{sequence}'")
    end
  end

end
