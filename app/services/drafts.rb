class Drafts
    def hoge
        m_i = [2, 3]
        num = [1, 10, 100, 1000, 10000] => [10, 100]
        num[i]
    end



    def create
        Validation.validate_form(params)
        Validation.validate_suit(params)
        Judge.judge_hand(params)
      end
    
end