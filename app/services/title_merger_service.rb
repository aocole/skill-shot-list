class TitleMergerService
  class << self
    def merge(title, into:)
      Machine.transaction do
        Machine.unscoped.where(title_id: title.id).update_all(title_id: into.id)
        if into.ipdb_id.nil?
          into.ipdb_id = title.ipdb_id
        end
        title.destroy
        into.save if into.changed?
      end
    end
  end
end