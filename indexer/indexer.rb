class IndexerCommon

	add_indexer_initialize_hook do |indexer|

    indexer.add_document_prepare_hook {|doc, record|
      if record['record']['jsonmodel_type'] == 'archival_object'
        doc['component_id_u_sstr'] = record['record']['component_id']
      end
    }
  end
end
