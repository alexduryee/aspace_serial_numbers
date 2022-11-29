# mss_id_generation

This plugin manages serial number generation for NYPL-created collections.

Since this re-uses existing fields, no changes to data export are needed.

** NOTE: THIS IS FOR DEMONSTRATION PURPOSES ONLY - REQUIRES OTHER CODE TO BE FULLY FUNCTIONAL **

## Changes made

- One new entry in the `Sequence` model - `component_mss_id`.  As per the `Sequence` model, it increments by 1 each time `Sequence.get` is invoked.
- The `ArchivalObject` model now calls `Sequence.get` when `ArchivalObject.component_id` is saved without a value.
