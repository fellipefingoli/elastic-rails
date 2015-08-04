class ElasticRails 
	
	attr_reader :client, :custom_index, :model

	def initialize index_name, model_name = nil
		@client = Elasticsearch::Client.new url: Rails.configuration.elasticsearch[:url]		
    	custom_name = ENV['CUSTOM_NAME'].downcase+"_"+index_name
    	@model = model
    	@custom_index = {
			name:  custom_name,
			write: custom_name+"_write",
			read:  custom_name+"_read"
		}
	end

	def import_all_to_elastic
		create_index
	    @client.bulk self.denormalize.map{|value| create_body value}
	    delete_index
	end

	def create_index
		current_index = @custom_index[:name]+"_"+Time.now.to_i.to_s
		@client.indices.create index(current_index)

		begin 
			@client.indices.get_alias(name: @custom_index[:write]).each do |index,aliases|
				@client.indices.delete_alias index: index, name: @custom_index[:write]
			end	
		rescue
			puts "Erro ao excluir alias do indice atual"
		end
		@client.indices.put_alias index: current_index, name: @custom_index[:write]
    end

    def delete_index
    	@client.indices.get_alias(name: @custom_index[:read]).each do |index,aliases|
			@client.indices.delete index: index
		end
		@client.indices.get_alias(name: @custom_index[:write]).each do |index,aliases|
			@client.indices.put_alias index: current_index, name: @custom_index[:read]
		end
    end

    private

    def index index_name
    	obj = {}
    	obj[:index] = index_name
    	obj[:mappings] = mapping if mapping.nil?
    	return obj
    end

	def create_body value
    	{index: {_index: @custom_index[:write], _type: @custom_index[:name] , _id: value[:id], data: value }}
    end

    def mapping
    	return nil
    end
	
	def denormalize id = nil
		id.nil? ? @model.all : @model.find id
	end
end