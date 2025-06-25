module QuoteDocxSections
  class AdditionalWarrantiesSection
    def initialize(docx)
      @docx = docx
    end

    # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Layout/LineLength
    def build
      @docx.page
      @docx.h2 '2. Additional Warranties'
      @docx.list_style do
        type    :ordered
        level   0
        format  'lowerLetter'
        value   '%1.'
        align   :left
        indent  400
        left    800
        start   1
        restart 1
      end
      @docx.ol color: '595959' do
        li 'All Services are provided under the terms and conditions of this Order Form and the Terms of Service found here: http://www.cloverpop.com/terms-of-service/ (the “Agreement”). The person signing represents that he or she has the authority to bind the Client to this Agreement. Capitalized terms used in this Order Form but not defined herein shall have the meanings provided in the Terms of Service'
        li 'Client agrees to purchase the services as set out in the Fees section of this Order Form. All pricing and terms and conditions depend upon the Client’s execution and return of this Order Form no later than 5 business days from sending. (unless signed by Cloverpop)'
        li 'All fees will be invoiced upon signature of the Agreement by both parties (the “Effective Date”), in accordance with the Billing Period noted in the Fees section of this Order Form, or upon the issuance of a Customer purchase order. Payment terms are net 30 days, measured from the date of invoice unless otherwise stated in superseding “Master Service Agreement”'
        li 'The software subscription automatically renews under the same terms unless terminated per the cancellation terms in the Agreement.'
        li 'External / Third party data costs will be covered by Client; any costs will be approved by Client representative'
        li 'The cost of travel (flight expenses + accommodation) is not included in the proposal cost, will be billed on actuals and aligned with client vendor travel policy'
        li 'For any change in scope, workload/ requirements would be discussed and mutually agreed between client and Clearbox Decisions (dba. Cloverpop)'
      end
    end
    # rubocop:enable Metrics/AbcSize,Metrics/MethodLength,Layout/LineLength
  end
end
