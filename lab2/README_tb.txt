============================
README for DCLab Lab2
============================

Including File:

1. DE2_115/* : DE2-115相關設定檔。

2. testbench/

    a. python/* : 進行RSA256解碼時，電腦端的執行檔案。
                  以傳送加密訊息給FPGA，並接收回傳訊息輸出成檔案。

       -- usage

          - (Windows OS)    安裝python compiler
            (Mac OS/ Linux) 以command line執行即可

          - "python rs232.py"

          - 檢查輸出結果


    b. verilog/* : 檢查verilog code用的testbench

       -- usage

          - for Rsa256Core.sv: ncverilog +access+r [path to tb.sv]

          - for Rsa256Wrapper.sv: ncverilog +access+r [path to PipelineCtrl.v]\
                                  [path to PipelineTb.v] [path to test_wrapper.sv]

       [NOTICE]: ncverilog之後檔名的順序是重要的。順序更改可能導致error

3. README.txt : 就是....這個說明檔

4. Rsa256Core.sv : 進行演算法的核心部分

5. Rsa256Wrapper.sv : 負責控制RS232 protocol相關。包含讀取check bit或寫入/讀取資料等。

   [NOTICE]: 請善用testbench。切勿用燒到板子上的方式來debug... 會崩潰