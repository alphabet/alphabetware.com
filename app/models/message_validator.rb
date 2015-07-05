class MessageValidator < ActiveModel::Validator
	def validate(record)
		if record.from_phone == record.to_phone
			record.errors[:base] << "From phone and To phone can not the same"
		end
		if record.to_phone == FROM
			record.errors[:base] << "To phone can not the same as constant for SMS Account Phone"
		end
	end
end
