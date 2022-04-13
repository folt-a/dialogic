tool
extends PanelContainer

export(NodePath) var Audio_Button_Path = @"HBoxContainer/PlayAudioButton"
export(NodePath) var Text_Label_Path = @"HBoxContainer/RichTextLabel"

var audioPath = ''
var AudioButton
var TextLabel
onready var TextContainer = $HBoxContainer
onready var ColorRectElement = $ColorRect
onready var TextureRectElement = $TextureRect

var regex = RegEx.new()
# ルビ
var ruby_commands = []
var ruby_control:Control
var ruby_template:Label
var ruby_offset:Vector2 = Vector2.ZERO

"""
	Example of a HistoryRow. Every time dialog is logged, a new row is created.
	You can extend this class to customize the logging experience as you see fit.
	
	This class can be edited or replaced as long as add_history is implemented
"""

class_name HistoryRow

func _ready():
	TextLabel = get_node(Text_Label_Path)
	AudioButton = get_node(Audio_Button_Path)
	
	assert(TextLabel is RichTextLabel, 'Text_Label must be a rich text label.')
	assert(AudioButton is Button, 'Audio_Button must be a button.')
	
	regex.compile("\\[\\s*(nw|(nw|speed|signal|play|pause|r)\\s*=\\s*(.+?)\\s*)\\](.*?)")
	# ルビ追加
	ruby_control = Control.new()
	ruby_control.name = "RubyControl"
	add_child(ruby_control)
	ruby_control.rect_position = Vector2.ZERO
	# ルビテンプレート追加
	ruby_template = Label.new()
	ruby_template.name = "RubyTemplateLabel"
	add_child(ruby_template)
	ruby_template.visible = false


func add_history(historyString, newAudio=''):
#	TextLabel.append_bbcode(historyString)
#	文字置換
	var result = regex.search(historyString)
	
	var ruby_char_counts = 0
	while result:
		historyString = historyString.substr(0, result.get_start()) + historyString.substr(result.get_end())
		
		# insert ruby text ルビをふる漢字を表示文字に加える
		if result != null and result.get_string(2) == "r":
			ruby_commands.append([result.get_start()-1 + ruby_char_counts, result.get_string(2).strip_edges(), result.get_string(3).strip_edges()])
			# ルビをふる漢字を表示文字に加えると文字分ずれる
			var replaced_text = result.get_string(3).replace("＠","@")
			var ruby_text = replaced_text.split("@")[1]
			historyString = historyString.insert(result.get_start() + ruby_char_counts,ruby_text)
			ruby_char_counts = ruby_char_counts + ruby_text.length()
			
		result = regex.search(historyString)
		
	TextLabel.bbcode_text = historyString.replace('[br]', '\n')
	add_rubies()
	
	audioPath = newAudio
	if newAudio != '':
		AudioButton.disabled = false
		AudioButton.icon = load("res://addons/dialogic/Images/Event Icons/Main Icons/audio-event.svg")
		AudioButton.flat = false
	else:
		AudioButton.disabled = true
		#AudioButton.icon = load("res://addons/dialogic/Images/Event Icons/Main Icons/text-event.svg")
	AudioButton.focus_mode = FOCUS_NONE


# Load Theme is called by 
func load_theme(theme: ConfigFile):
	# Text
	var theme_font = DialogicUtil.path_fixer_load(theme.get_value('text', 'font', 'res://addons/dialogic/Example Assets/Fonts/DefaultFont.tres'))
	TextLabel.set('custom_fonts/normal_font', theme_font)
	TextLabel.set('custom_fonts/bold_font', DialogicUtil.path_fixer_load(theme.get_value('text', 'bold_font', 'res://addons/dialogic/Example Assets/Fonts/DefaultBoldFont.tres')))
	TextLabel.set('custom_fonts/italics_font', DialogicUtil.path_fixer_load(theme.get_value('text', 'italic_font', 'res://addons/dialogic/Example Assets/Fonts/DefaultItalicFont.tres')))
	#name_label.set('custom_fonts/font', DialogicUtil.path_fixer_load(theme.get_value('name', 'font', 'res://addons/dialogic/Example Assets/Fonts/NameFont.tres')))
	
	#Ruby
	ruby_template.set('custom_fonts/font', DialogicUtil.path_fixer_load(theme.get_value('text', 'ruby_font', 'res://addons/dialogic/Example Assets/Fonts/DefaultRubyFont.tres')))
	ruby_template.align = theme.get_value('text', 'ruby_alignment',0)
	ruby_offset = theme.get_value('text', 'ruby_offset', Vector2(2,2))
	
	# setting the vertical alignment
	var alignment = theme.get_value('text', 'alignment',0)
	if alignment <= 2: # top
		TextContainer.alignment = BoxContainer.ALIGN_BEGIN
	elif alignment <= 5: # center
		TextContainer.alignment = BoxContainer.ALIGN_CENTER
	elif alignment <= 8: # bottom
		TextContainer.alignment = BoxContainer.ALIGN_END
	
	var text_color = Color(theme.get_value('text', 'color', '#ffffffff'))
	TextLabel.set('custom_colors/default_color', text_color)
	#name_label.set('custom_colors/font_color', text_color)
	
	var ruby_color = Color(theme.get_value('text', 'ruby_color', '#ffffffff'))
	ruby_template.set('custom_colors/font_color', ruby_color)

	TextLabel.set('custom_colors/font_color_shadow', Color('#00ffffff'))
	#name_label.set('custom_colors/font_color_shadow', Color('#00ffffff'))

	if theme.get_value('text', 'shadow', false):
		var text_shadow_color = Color(theme.get_value('text', 'shadow_color', '#9e000000'))
		TextLabel.set('custom_colors/font_color_shadow', text_shadow_color)

	var shadow_offset = theme.get_value('text', 'shadow_offset', Vector2(2,2))
	TextLabel.set('custom_constants/shadow_offset_x', shadow_offset.x)
	TextLabel.set('custom_constants/shadow_offset_y', shadow_offset.y)

	# Margin
	var text_margin = theme.get_value('text', 'margin', Vector2(20, 10))
	TextContainer.set('margin_left', text_margin.x)
	TextContainer.set('margin_right', text_margin.x * -1)
	TextContainer.set('margin_top', text_margin.y)
	TextContainer.set('margin_bottom', text_margin.y * -1)

	# Backgrounds
	TextureRectElement.texture = DialogicUtil.path_fixer_load(theme.get_value('background','image', "res://addons/dialogic/Example Assets/backgrounds/background-2.png"))
	ColorRectElement.color = Color(theme.get_value('background','color', "#ff000000"))

	if theme.get_value('background', 'modulation', false):
		TextureRectElement.modulate = Color(theme.get_value('background', 'modulation_color', '#ffffffff'))
	else:
		TextureRectElement.modulate = Color('#ffffffff')

	ColorRectElement.visible = theme.get_value('background', 'use_color', false)
	TextureRectElement.visible = theme.get_value('background', 'use_image', true)
	
var SPACING = 24
var SPACING_EXTRA = 3
func add_rubies():
	var m_label: RichTextLabel = TextLabel
	var m_font: DynamicFont = m_label.get("custom_fonts/normal_font")
	
	for label in ruby_control.get_children():
		ruby_control.remove_child(label)
	
	for command in ruby_commands:
		var replaced_ruby = command[2].replace("＠","@")
		var ruby_furigana = replaced_ruby.split("@")[0]
		var ruby_text = replaced_ruby.split("@")[1]
		var ruby = {"text":ruby_text,"furigana":ruby_furigana,"t_idx":command[0] + 1,"t_len":ruby_text.length()}
		# ルビ用Labelを複製
		var r_label: Label = ruby_template.duplicate()
		var r_font: Font = r_label.get_font("font")
		# ルビを指定
		r_label.text = ruby.furigana
		
#		# ルビのLabelが最小となるように設定
		ruby_control.add_child(r_label)
		
		# サイズ・テキスト類の取得
		# ルビふりがな
		var r_size: Vector2 = r_font.get_string_size(ruby.furigana)
		var r_len: int = r_label.text.length()
		# ルビ対象テキスト
		var t_size: Vector2 = m_font.get_string_size(ruby.text)
		# テキスト全体
		var m_text: String = m_label.text
		var m_size: Vector2 = m_font.get_string_size(m_text)
		var m_text_lines: Array = m_text.split("\n")
		m_size.y += m_size.y * (m_text_lines.size() - 1)
		var _li = 0
		# ルビの存在する行
		var m_text_line: String = m_text_lines[_li]
		var _lidx: int = m_text_line.length()
		if _lidx > 0:
			while _lidx < ruby.t_idx:
				_li += 1
				m_text_line = m_text_lines[_li]
				_lidx += m_text_line.length() + 1
		var m_text_line_size: Vector2 = m_font.get_string_size(m_text_line)
		# メッセージのうち、テキスト直前までのもの
		var m_pre_text: String = m_text.substr(0, ruby.t_idx)
		var m_pre_size: Vector2 = m_font.get_string_size(m_pre_text)
		var m_pre_nl_count: int = m_pre_text.count("\n")
		m_pre_size.y += m_pre_size.y * m_pre_nl_count
		# メッセージのテキスト直前までのもののうち、改行以降のもの
		var m_pre_after_nl_idx: int = m_pre_text.find_last("\n")
		var m_pre_after_nl_size: Vector2 = m_font.get_string_size(m_pre_text.substr(m_pre_after_nl_idx + 1)) if m_pre_after_nl_idx >= 0 else m_pre_size

		# ルビ長が対象より短い場合、スペースを入れて埋める
		if r_font is DynamicFont and r_size.x < t_size.x:
			r_font = r_font.duplicate()
			r_font.extra_spacing_char = int((t_size.x - r_size.x) / r_len)
			r_label.set("custom_fonts/font", r_font)
			r_size.x += (r_len - 1) * r_font.extra_spacing_char
		# ラベルNodeの横幅をルビ対象テキストの横幅に合わせるが、
		# スペースで埋めた結果ルビLabel横幅が対象より長くなる場合はその長さにする
		if r_size.x > t_size.x:
			r_label.rect_size.x = r_size.x
		else:
			r_label.rect_size.x = t_size.x
		
		# ルビラベルの大きさ、位置を決める	
		var r_pos_x: float = 0
		if m_label.rect_size.x != 0:
			r_pos_x = int(m_pre_after_nl_size.x) % int(m_label.rect_size.x)
		var r_pos_y: float = (m_text_line_size.y * m_pre_nl_count + SPACING - r_size.y + SPACING_EXTRA * m_pre_nl_count) - ((m_text_lines.size() - 1) * m_text_line_size.y)
		
		# 真ん中揃えかつルビLabel横幅が対象より長くなった場合はルビテキストの中央に合わせる
		if r_label.align == Label.ALIGN_CENTER and r_size.x > t_size.x:
			var zurasi_x = (r_size.x - t_size.x) / 2.0
			r_pos_x = r_pos_x - zurasi_x
		
		var r_pos: Vector2 = Vector2(r_pos_x + ruby_offset.x, r_pos_y + ruby_offset.y - 60)
		r_label.rect_position = r_pos
		r_label.visible = true
