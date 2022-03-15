# Dialogic ルビ機能追加

このリポジトリは、Godotの高機能会話ウィンドウアドオン [**Dialogic**](https://github.com/coppolaemilio/dialogic/)をフォークし、ルビ機能を追加したものです。

## 事前準備

DialogicとGodotの初期フォントは日本語が含まれていないため、日本語が表示できません。日本語フォントを別途用意してください。<br>
[Google Fonts](https://fonts.google.com/?subset=japanese)とかいっぱいあっておすすめです。ゲーム組み込みもだいたいOKのはずです。（使う時はしっかり確認してください）

## ルビ機能使い方

1. Dialogic を addons ディレクトリに配置します。<br>プロジェクト設定→プラグインから Dialogic を有効化します。<br>その後プロジェクトを再起動してアドオンを反映させます。
2. 上部に **Dialogic** タブが追加されています。開きます。  
![image](https://user-images.githubusercontent.com/32963227/152312398-48a0e347-d33f-4db1-b04b-60c854aa2160.png)
3. 左部のサイドバーの **Theme → Default Theme** を選択します。  
**Dialog Text** タブの**Fonts**列に、**Ruby Font, Ruby Alignment, Ruby Offset** 、**Colors**列に **Ruby Color** が追加されています。
![image](https://user-images.githubusercontent.com/32963227/158387168-a13492bf-6415-4fe1-b858-a034c3181461.png)

|   |初期値|説明|
|---|---|---|
|Ruby Font|res://addons/dialogic/Example Assets/Fonts/DefaultRubyFont.tres<br>FontDataのOverlock-Regular.ttfが英語フォントなので日本語フォントに変えること|ルビに使用するフォントリソースです。**DynamicFont** リソースを推奨します。<br>新しくフォントのリソースを作って設定するか（おすすめ）、 DefaultRubyFont の FontData を変更します。（おすすめしない）|
|   |   |extra_spacing_charはプログラム内で自動に設定されるため、変更しても意味がないかもです。|
|Ruby Alignment|Center|ルビを左寄せ、真ん中、右寄せ、Fillします。<br>Fillは使い物にならないかもです。（よくわかっていません）|
|Ruby Offset|X:0 Y:0|ルビを指定したピクセルぶんずらします。<br>これで微調整してください。|
|Ruby Color||ルビの色|
4. 左部のサイドバーの **Timeline → 右クリック → Add Timeline** を実行してタイムラインを追加してみます。名前をひかえておきます。  
（Themeエディタのプレビュー欄でもルビは表示されますが）
5. テキストイベントを追加します。右部の Main Events から 💬Text をクリックします。<br>
![image](https://user-images.githubusercontent.com/32963227/152315392-7176aa39-a7b7-4da5-9b80-6f851a9d316e.png)
6. テキストを入力します。<br>
![image](https://user-images.githubusercontent.com/32963227/152315472-4b6a26db-c8b6-4ae4-a177-489e469380db.png)
例文
```
[r=ごどー@Godot][r=えんじん@Engine]のアドオン[r=ダイアロジック@Dialogic]でルビを[r=ふ@振]るよ。[br][r=ハードラック＠不運]と[r=ダンス@踊]っちまった。
```
書き方
```
[r=ルビふりがな@ルビをふる文字]
```

＠がルビと文字の区切りです。（そのため、＠をルビや文字に使うことはできません。）

＠は全角、半角どちらでも可です。

[r=]はすべて半角です。

7. 適当にNode2Dでシーンを作成し、スクリプトを作成 → アタッチします。  
スクリプトを書きます。Timelineの文字列は、先程作成したタイムラインの名前と同じにする必要があります。
<br>

![image](https://user-images.githubusercontent.com/32963227/152316501-039f46cc-cc0f-460a-af9c-8cf5ce7e6ed6.png)


```gdscript
extends Node2D

func _ready():
	var dia = Dialogic.start('timeline-1643877658')
	self.add_child(dia)
```

8. シーンを保存してF6とかで実行します。
![image](https://user-images.githubusercontent.com/32963227/152316989-5e220330-9fb5-4bf5-b808-338f1fa79540.png)

---
ライセンス
MIT

---

参考にさせていただきました

[Godot Engine上で振り仮名（ルビ）を実現する](https://www.clvs7.com/blog/2020/09/24/implementing-furigana-ruby-on-godot/)

[https://gitlab.com/clvs7/godot-sample-project-furigana-ruby](https://gitlab.com/clvs7/godot-sample-project-furigana-ruby)

---

↓以下は Dialogic 本リポジトリのReadMe

---

![dialogic-new-cover](https://user-images.githubusercontent.com/2206700/152978050-9e9f837d-1c2f-4281-b76d-67900c829534.png)
![dialogic-cover](https://user-images.githubusercontent.com/2206700/156223574-5052c607-408e-4143-80b5-c4aed1cf29a2.png)

Create dialogs, characters and scenes to display conversations in your Godot games. 

[Changelog](https://github.com/coppolaemilio/dialogic/blob/main/addons/dialogic/Documentation/Content/Changelog.md) — 
[Installation](#installation) — 
[Documentation](https://github.com/coppolaemilio/dialogic/blob/main/addons/dialogic/Documentation/Content/Welcome.md) — 
[Credits](#credits)



# Version 1.4 - Curves Ahead  ![Godot v3.4](https://img.shields.io/badge/godot-v3.4-%23478cbf)

## Getting started

You can read a step by step guide on how to use [Dialogic here](https://github.com/coppolaemilio/dialogic/blob/main/addons/dialogic/Documentation/Content/Tutorials/BeginnersGuideStepByStep.md)

## 📚 Documentation
You can check the documentation from inside the plugin or [here](https://github.com/coppolaemilio/dialogic/blob/main/addons/dialogic/Documentation/Content/Welcome.md)

## Installation

To install a Dialogic, download it as a ZIP archive. All releases are listed here: [releases](https://github.com/coppolaemilio/dialogic/releases). Then extract the ZIP archive and move the `addons/` folder it contains into your project folder. Then, enable the plugin in project settings.

If you want to know more about installing plugins you can read the [Godot docs page](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html).

You can also install Dialogic using the **AssetLib** tab in the editor, but the version here will not be the latest one available since it takes some time for it to be approved.

## ⚠ IMPORTANT
If you encounter any issue when exporting your game, try having at least 1 theme in your project.

---

## 📃 Credits
Made by [Emilio Coppola](https://github.com/coppolaemilio).

Contributors: [Jowan-Spooner](https://github.com/Jowan-Spooner), [Arnaud](https://github.com/arnaudvergnet), [ellogwen](https://github.com/ellogwen), [Tim Krief](https://github.com/timkrief), [zaknafean](https://github.com/zaknafean), [and more!](https://github.com/coppolaemilio/dialogic/graphs/contributors). Special thanks: [Toen](https://twitter.com/ToenAndreMC), Òscar, [Francisco Presencia](https://francisco.io/). Placeholder images are from [Toen's](https://toen.world/) [YouTube DF series](https://www.youtube.com/watch?v=B1ggwiat7PM)

### Thank you to all my [Patreons](https://www.patreon.com/coppolaemilio) for making this possible!

Mike King,
Tyler Dean Osborne,
Problematic Dave,
Allyson Ota,
Francisco Lepe,
Gemma M. Rull,
Alex Barton,
Joe Constant,
Kycho,
JDA,
Kersla Margdel,
Chris Shove,
Luke Peters,
Wapiti,
Penny,
Garrett Guillotte,
Sl Tu,
Alex Harry,
Rokatansky,
Karl Anderson,
GammaGames,
Taankydaanky,
Alex (Well Done Games),
GodofGrunts,
Tim Krief,
Daniel Cheney,
Carlo Cabanilla,
Flaming Potato,
Joseph Catrambone,
AzulCrescent,
Hector Na Em,
Furroy,
Sergey,
Container7,
BasicIncomePlz,
p sis,
Justin,
Guy Dadon,
Sukh Atwal,
Patrick Hogan,
Jesse Priest,
Lunos,
Ceah Sharp,
Mark Charnock



Support me on [Patreon https://www.patreon.com/coppolaemilio](https://www.patreon.com/coppolaemilio)

[MIT License](https://github.com/coppolaemilio/dialogic/blob/main/LICENSE)
