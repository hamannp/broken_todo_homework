shared_examples 'soft delete examples' do |factory_name|
  describe "SoftDelete" do
    let(:factory_name) { :item }
    let(:model_class) { factory_name.to_s.classify.constantize }

    context "retrieving records" do
      let!(:record) { FactoryBot.create(factory_name) }
      let!(:soft_deleted_record) { FactoryBot.create(factory_name, :deleted) }

      specify '#all returns only non-deleted records by default' do
        expect(model_class.all).to eq [record]
      end

      specify '#only_deleted returns just the deleted records' do
        expect(model_class.only_deleted).to eq [soft_deleted_record]
      end

      specify '#with_deleted returns all records, regardless if marked deleted' do
        expect(model_class.with_deleted).to match_array([record, soft_deleted_record])
      end
    end

    context "destroying records" do
      specify "#destroy marks the record deleted but does not remove it" do
        record = FactoryBot.create(factory_name)
        record.destroy

        expect(record.deleted_at).to_not be_nil
        expect(model_class.unscoped.exists?(record.id)).to be true
      end

      specify "#destroy! removes the record from the database" do
        record = FactoryBot.create(factory_name)
        record.destroy!

        expect(model_class.unscoped.exists?(record.id)).to be false
      end
    end

    context "restoring records" do
      let!(:soft_deleted_record) { FactoryBot.create(factory_name, :deleted) }

      specify "#restore unmarks the record and makes it available in the default scope" do
        expect(model_class.exists?(soft_deleted_record.id)).to be false

        soft_deleted_record.restore

        expect(model_class.exists?(soft_deleted_record.id)).to be true
      end
    end
  end

end
