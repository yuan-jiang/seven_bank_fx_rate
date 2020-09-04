# frozen_string_literal: true

module SevenBankFxRate
  module Elements
    # Corresponds to the header tag in xml:
    # <header>
    #   <createdate>20200903</createdate>
    #   <applydate>20200903</applydate>
    #   <applytime>0800</applytime>
    #   <datacount>0288</datacount>
    # </header>
    class Meta
      attr_accessor :create_date, :apply_date, :apply_time, :data_count
    end
  end
end
