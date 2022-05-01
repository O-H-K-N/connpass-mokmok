namespace :record_limit do
  desc 'クイズが出題されてから１日経っても回答されていない場合、無回答で回答済となる'
	task checked_record: :environment do
		Record.limit_over.find_each(&:checked!)
	end
end
