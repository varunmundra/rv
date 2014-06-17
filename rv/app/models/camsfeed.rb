class Camsfeed < ActiveRecord::Base
	
	def self.import(file)
	  allowed_attributes = [ "amc_code","folio_no","prodcode","scheme","inv_name","trxntype","trxnno","trxnmode",	"trxnstat",
	  	"usercode",	"usrtrxno",	"traddate",	"postdate",	"purprice",	"units",	"amount",	"brokcode",	"subbrok"	,"brokperc",
	  	"brokcomm",	"altfolio"	,"rep_date",	"time1",	"trxnsubtyp",	"application_no",	"trxn_nature",	"tax",	"total_tax",
	  	"te_15h",	"micr_no",	"remarks",	"swflag",	"old_folio",	"seq_no",	"reinvest_flag",	"mult_brok",	"stt",	"location",
	  	"scheme_type",	"tax_status",	"load",	"scanrefno",	"pan",	"inv_iin"	,"targ_src_scheme",	"trxn_type_flag",
	  	"ticob_trtype",	"ticob_trno",	"ticob_posted_date",	"dp_id",	"trxn_charges",	"eligib_amt",	"src_of_txn",	"trxn_suffix",
	  	"siptrxnno",	"ter_location",	"euin",	"euin_valid",	"euin_opted",	"sub_brk_arn"]
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(1)
	  (2..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
	    camsfeed = Camsfeed.new
	    camsfeed.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
	    camsfeed.save!
	  end
	end

	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
	  when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
	  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
	  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
	  else raise "Unknown file type: #{file.original_filename}"
	  end
	end

	
end
