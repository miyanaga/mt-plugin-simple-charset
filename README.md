# mt-plugin-simple-charset

Movable Typeに文字コードを変換するmt:SimpleCharsetタグと、拡張子による文字コードの指定機能を提供します。

## SimpleCharsetタグ

テンプレートの任意の範囲を指定の文字コードに変更します。通常はテンプレート全体に適用します。

    <mt:SimpleCharset to="CP932">
    この内容をCP932(Windows Shift_JIS)に変換します。
    </mt:SimpleCharset>

* `to` 変換先の文字コードを指定します。
* `from` 変換元の文字コードを指定します。指定しない場合は`PublishCharset`環境変数が利用されます。

## CharsetByExt環境変数

再構築するファイルの拡張子ごとに文字コードを変更します。

`拡張子:文字コード`の組み合わせで指定し、セミコロン`;`で区切ることで複数指定することができます。

    CharsetByExt inc: CP932; euc.html: EUC-JP

## 文字コードの指定方法について

`Encode`モジュールでの指定方法に準拠します。
