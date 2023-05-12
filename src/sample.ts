// スクリプトプロパティを使う
const sp = PropertiesService.getScriptProperties();
const hoge = sp.getProperty('HOGE'); // HOGEというプロパティ名の値をスクリプトプロパティから取得しhogeに格納


// GASのスクリプトファイルとは別のスプレッドシートを操作する

const main = () => {
  const targetSheetId = 'xxxxxxxxxxxxxxxxxxxxxxxxxx'; //スプレッドシートのURLから取ってきたIDを入れる
  const ss = SpreadsheetApp.openById(targetSheetId);
  const sheet = ss.getSheetByName('シート1');
  Logger.log(sheet.getRange('B2').getValue()); // B2セルの内容を出力
}