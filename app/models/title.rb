class Title < ApplicationRecord
  DEFAULT_ORDER = "regexp_replace(name, '^The ', '')"
  default_scope -> {where(['status IS NULL OR status != ?', STATUS::HIDDEN]).order(Arel.sql(DEFAULT_ORDER))}
  
  scope :active, -> { joins('as title inner join machines as machine on machine.title_id=title.id') }

  class STATUS
    HIDDEN = 'hidden'
  end
  
  validates_uniqueness_of :ipdb_id, allow_nil: true
  validates_presence_of :name
  validates_inclusion_of :status, in: STATUS.constants.collect{|name|STATUS.const_get(name)}, allow_nil: true
  has_many :machines
  has_many :locations, through: :machines

  def ipdb_url
    ipdb_id ? "http://ipdb.org/machine.cgi?gid=#{ipdb_id}" : nil
  end

  def sort_name
    name.sub(/^the /i, '').downcase
  end

  def <=> other
    self.sort_name <=> other.sort_name
  end

  def self.count_active
    active.count('distinct title.id')
  end
end
