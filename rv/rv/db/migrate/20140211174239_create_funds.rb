class CreateFunds < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.string :scheme_amfi_name
      t.string :scheme_name
      t.string :amc_name
      t.string :amfi_code
      t.string :asset_type
      t.string :category
      t.string :category_sub
      t.string :fund_type
      t.string :classification
      t.string :registrar
      t.string :registrar_scheme_code
      t.string :registrar_amc_code
      t.string :benchmark
      t.string :exit_load
      t.integer :min_investment
      t.integer :investment_inc
      t.date :launch_date
      t.string :sip_available
      t.integer :min_sip_investment
      t.integer :min_sip_chqs
      t.float :expense_ratio
      t.string :colour_code
      t.string :fund_manager
      t.string :fund_manager2
      t.float :net_assets
      t.float :fund_1month
      t.float :benchmark_1month
      t.float :fund_3month
      t.float :benchmark_3month
      t.float :fund_6month
      t.float :benchmark_6month
      t.float :fund_ytd
      t.float :benchmark_ytd
      t.float :fund_1month_anl
      t.float :benchmark_1month_anl
      t.float :fund_3month_anl
      t.float :benchmark_3month_anl
      t.float :fund_6month_anl
      t.float :benchmark_6month_anl
      t.float :fund_ytd_anl
      t.float :benchmark_ytd_anl
      t.float :fund_1year
      t.float :benchmark_1year
      t.float :fund_2year
      t.float :benchmark_2year
      t.float :fund_3year
      t.float :benchmark_3year
      t.float :fund_5year
      t.float :benchmark_5year
      t.float :since_inception
      t.float :since_inception1
      t.float :ratio_exp
      t.float :fund_alpha
      t.float :fund_stddev
      t.float :fund_sortino
      t.float :fund_sharpe
      t.float :treynor
      t.date :ratio_as_on
      t.float :fund_beta
      t.string :rating_vr
      t.float :maturity_yld
      t.float :maturity_avg_yr
      t.float :dur_mod_yr
      t.float :equity_cr
      t.float :debt_cr
      t.float :other_cr
      t.string :no_of_stocks
      t.float :portfolio_pb_ratio
      t.float :portfolio_pe_ratio
      t.string :datasource_code 
      t.string :pg_amc_code
      t.string :pg_scheme_code
      t.string :prodcode
      t.float :nav


      t.timestamps
    end
  end
end
