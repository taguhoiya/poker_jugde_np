class Validation

    def self.validate_form(params)
        @array = params[:array]
        @m_array = @array.scan(/[A-Z]/)
        @m_array_scanned = @array.scan(/[CDHS]/)

        
        @string = @array.gsub(/[[:space:]]/, '')
        @n_array = @string.split(/[A-Z]/).drop(1)
        @strtoint = @n_array.map{|n| n.to_i}

        @make_array = @array.split(" ")       


        @scan_m = @m_array_scanned.count
        @scan_space = @array.scan(/ +/)

        @count_n = @n_array.uniq.count
        @count_m = @m_array_scanned.uniq.count
    
        @sort_n = @strtoint.sort
        @variation = @sort_n[4] - @sort_n[0]
    
        @count_overlap = @strtoint.group_by(&:itself).map{ |key, value| [key, value.count] }.sort{ |a, b| a[1] <=> b[1] }
        @get_value = @count_overlap.map{|row| row[1]}
    
        for num in 1..9
          @arrange = [num, num+1, num+2, num+3, num+4]
        end

        # emptyでないかまずバリデーション
        if params[:array].empty?
            @text = "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"

        #スートが正しいか(CDHS以外のアルファベットを入れた場合)
        elsif @scan_m >= 1 && @scan_m <= 4
            @text = "入力されたマークが指定の4種類ではありません。半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
    
        # #数字が正しいか => n番目が不正ですをたす。
        # elsif @strtoint.any? { |x| x >= 14 }
        #     @text = "入力された数字が指定のものではありません。半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
    
        # elsif @strtoint.any? { |x| x <= 0 }
        #     @text = "入力された数字が指定のものではありません。半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
    
        # カードが重複していないか
        elsif @make_array.uniq.count >= 1 && @make_array.uniq.count <= 4
            @text = "カードが重複しています。"
        
        #余分なスペースがないかバリデーション（二文字以上のスペース＋文頭文末に１文字以上のスペース＋カードが五枚入力されているか）
        elsif @array.scan(/  +/).present?
            @text = "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
    
        elsif @array.scan(/^ +/).present? && @array.scan(/ +$/).present?
            @text = "先頭にも末尾にもスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
        
        elsif @array.scan(/^ +/).present?
            @text = "先頭にスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
    
        elsif @array.scan(/ +$/).present?
            @text = "末尾にスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
        end

    end

    def self.validate_suit(params)
        
        @error_m = @m_array.reject {|e| e =~ /[CDHS]/}
        @error_n = @strtoint.select {|x| x > 13 || x == 0}
        if @error_m
            @error_m.each do |e_m|　
                @m_index = @m_array.each_index.select { |n| @m_array[n] == e_m } # m_i=> [2, 3]
                @m_index.each do |m_i| # 2と3番目のマークを取り出して配列に
                    @foo = @strtoint[m_i]
                    @text =  "#{m_i}番目のカード指定文字が不正です。（#{e_m}#{@foo}）"
                    p @text
                end          
            end

        elsif @error_n
            @error_n.each do |e_n| # @strtoint.each_index = [1, 10, 100, 1000, 10000]
                @n_index = @strtoint.each_index.select { |n| @strtoint[n] == e_n }
                @n_index.each do |n_i| # 2と3番目のマークを取り出して配列に
                    @hoge = @m_array_scanned[n_i]
                    @text =  "#{n_i}番目のカード指定文字が不正です。（#{@hoge}#{e_n}）"
                    p @text
                end   
            end
        end
    end
end