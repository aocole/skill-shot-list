class Title < ActiveRecord::Base
  default_scope order("trim(leading 'The ' from name)")

  class STATUS
    HIDDEN = 'hidden'
  end
  default_scope where(['status IS NULL OR status != ?', STATUS::HIDDEN]).order('name asc')
  validates_uniqueness_of :ipdb_id
  validates_presence_of :name
  validates_inclusion_of :status, :in => STATUS.constants.collect{|name|STATUS.const_get(name)}, :allow_nil => true
  has_many :machines
  has_many :locations, :through => :machines

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
    count('distinct title.id', :joins => 'as title inner join machines as machine on machine.title_id=title.id')
  end
end
