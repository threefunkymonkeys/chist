require 'securerandom'
require_relative '../../models/chist'

Sequel.migration do
  up do
    chists = Chist.all
    backup = chists.dup
    Chist.dataset.destroy
    drop_column :chists, :id
    add_column :chists, :id, :Uuid, primary_key: true
    backup.each { |chist|
      hash = chist.to_hash
      hash[:id] = SecureRandom.hex
      Chist.create(hash)
    }
  end

  down do
    chists = Chist.all
    backup = chists.dup
    Chist.dataset.destroy
    drop_column :chists, :id
    add_column :chists, :id, :serial, primary_key: true
    backup.each { |chist|
      hash = chist.to_hash
      hash.delete(:id)
      Chist.create(hash)
    }
  end
end
