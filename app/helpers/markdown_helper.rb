module MarkdownHelper
  def markdown(text)
    return '' if text.blank?
    
    options = {
      filter_html: true,
      hard_wrap: true,
      space_after_headers: true,
      with_toc_data: true,
      fenced_code_blocks: true,
      tables: true
    }
    
    extensions = {
      autolink: true,
      superscript: true,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true,
      lax_spacing: true,
      strikethrough: true,
      tables: true,
      highlight: true
    }
    
    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    
    # CodeRay によるシンタックスハイライト
    content = markdown.render(text)
    content = syntax_highlight(content)
    content.html_safe
  end
  
  private
  
  def syntax_highlight(html)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    
    doc.css('pre code').each do |code|
      # コードブロックのクラス名から言語を抽出
      lang = code['class'] ? code['class'].sub('language-', '') : 'text'
      
      # コードをハイライト
      highlighted = CodeRay.scan(code.text.strip, lang.to_sym).div(
        css: :class,
        line_numbers: :table,
        tab_width: 2
      )
      
      # ハイライトされたHTMLで置き換え
      code.parent.replace(highlighted)
    end
    
    doc.to_html
  end
end