#= require jquery
#= require jquery_ujs

$ ->
	shimSize = ->
		len = $(".block").length
		h = $(window).height() - 2 - (36+22) * len
		$(".block").height(h/len)
		console.log $(window).height()
	getParam = ->
		param = {}
		$('.contentsArea').each ->
			param[$(@).data('type')] = $(@).data('idx')
		param
	$('a.pager').bind 'click',->
		param = getParam()
		param[$(@).data('type')] += $(@).data('add')
		@href = @href + '?' + $.param param
	$(window).resize ->
		shimSize()
	shimSize()