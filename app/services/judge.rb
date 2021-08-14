class Judge_hand
    require_relative './validation.rb'

    def self.judge_hand(params)
        #ロイヤルストレートフラッシュ…同じマークのA・K・Q・J・10
        if @sort_n == [1, 10, 11, 12, 13]   && @count_m == 1 
            @text = "ロイヤルストレートフラッシュ"
        
        #ストレートフラッシュ…同じマークで連番
        elsif @count_m == 1 && @variation == 4
            @text = "ストレートフラッシュ" 
        
        #フォーカード…同じ数字が4枚
        elsif @get_value == [1, 4]
            @text = "フォーカード"
    
        #フルハウス…同じ数字が3枚と同じ数字が2枚の組み合わせ
        elsif @get_value == [2, 3]
            @text = "フルハウス"
    
        #ストレート…連番
        elsif @count_n == 5  && @variation == 4
            @text = "ストレート"
    
        #フラッシュ…同じマークが5枚
        elsif @count_m == 1 && @count_n == 5
            @text = "フラッシュ"
        
        #スリーカード…同じ数字が3枚
        elsif @get_value == [1, 1, 3] 
            @text = "スリーカード"
    
        #ツーペア
        elsif @get_value == [1, 2, 2] 
            @text = "ツーペア"
    
        #ワンペア
        elsif @get_value == [1, 1, 1, 2]
            @text = "ワンペア"
    
        #ハイカード
        else
            @text = "ハイカード"
        end
    
    end
end