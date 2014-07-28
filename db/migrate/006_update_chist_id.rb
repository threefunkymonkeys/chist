require 'securerandom'
require_relative '../../models/chist'

Sequel.migration do
  up do
    chists = Chist.all
    backup = chists.dup
    chists.each { |chist| chist.destroy }
    drop_column :chists, :id
    add_column :chists, :id, String, primary_key: true
    backup.each { |chist|
      hash = chist.to_hash
      hash[:id] = SecureRandom.hex
      Chist.create(hash)
    }
  end

  down do
    chists = Chist.all
    backup = chists.dup
    chists.each { |chist| chist.destroy }
    drop_column :chists, :id
    add_column :chists, :id, primary_key: true
    backup.each { |chist|
      hash = chist.to_hash
      hash.delete(:id)
      Chist.create(hash)
    }
  end
end
