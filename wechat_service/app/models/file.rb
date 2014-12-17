# encoding: utf-8
class DiskFile < ActiveRecord::Base
  def self.store_path
    "#{Rails.root}/files/"
  end

  def file_path

  end
end
