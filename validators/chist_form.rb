module ChistApp::Validators
  class ChistForm
    include Hatch

    certify('title', I18n.t('chists.errors.title')) do |title|
      !title.nil? && !title.empty?
    end

    certify('chist', I18n.t('chists.errors.chist')) do |chist|
      !chist.nil? && !chist.empty?
    end
  end
end
