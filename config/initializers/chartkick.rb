Chartkick.options = {
  donut: true, # ドーナツグラフ
  width: '300px',
  colors: [ "#88CCEE",
            "#CC6677",
            "gray",
          ],
  thousands: ",",
  suffix: "問",
  legend: false, # 凡例非表示
  library: { # ここからHighchartsのオプション
    title: {
      style: {
        color: 'black',
        fontFamily: "'ヒラギノ丸ゴ ProN','Hiragino Maru Gothic ProN'",
      },
      align: 'center',
      verticalAlign: 'middle',
    },
    chart: {
      backgroundColor: 'none',
      plotBorderWidth: 0,
      plotShadow: false
    },
    plotOptions: {
      pie: {
        dataLabels: {
          enabled: true,
          distance: -25, # ラベルの位置調節
          allowOverlap: false, # ラベルが重なったとき、非表示にする
          style: { #ラベルフォントの設定
            color: 'white',
            textAlign: 'center',
            fontSize: "small",
            textOutline: 0, #デフォルトではラベルが白枠で囲まれていてダサいので消す
          }
        },
        size: '100%',
        innerSize: '50%', # ドーナツグラフの中の円の大きさ
        borderWidth: 0,
      }
    },
  }
}