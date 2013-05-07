class Question
	constructor: () ->
		@questionIsStarted = false
		@nbVote =  0                                                                           
		@a_possibleAnswers = []        
		@a_userAnswersCount = []    
		@a_userName = []      
	##
	# 
	##
	startListening: () ->
		$('#list').bind('DOMNodeInserted', (e) =>
			elem = e.target
			insertValue = elem.innerText.toLowerCase()
			user = elem.dataset.sender
			if ((pos = $.inArray(insertValue, @a_possibleAnswers)) >= 0	and $.inArray(user, @a_userName) == -1)
				@a_userAnswersCount[pos]++
				$(".q_#{pos}").next().text(@a_userAnswersCount[pos]);
				@a_userName.push(user);
		)

	##
	# 
	##
	stopListening: () ->
		$('#list').unbind('DOMNodeInserted');

	##
	# 
	##
	initUIListener: () ->
		$('#btn-start').on('click', (e, elem) =>
			if @a_possibleAnswers.length > 0
				@questionIsStarted = not @questionIsStarted
				if @questionIsStarted
					@startListening()
					$(e.currentTarget).removeClass("btn-danger").addClass("btn-success")
					$(e.currentTarget).find("span.value").text("stop")
				else
					@stopListening()
					$(e.currentTarget).addClass("btn-danger").removeClass("btn-success")
					$(e.currentTarget).find("span.value").text("start")
			else
				alert 'You have to define some answers first.'
		)
		$('#change-question').editable(
			(value, settings) -> 
				value
			, 
			event : 'click'
			cancel : 'Cancel'
			submit : 'OK'
			indiciator : 'Saving..'
		)

		#
		# Create answer
		#
		$('form#add-answer').on('submit', (e) =>
			value = $('input#add-answer-value').val()
			num = @a_possibleAnswers.length
			$('#answers-list tbody').append("<tr><td class=\"q_#{num}\">#{value}</td><td class=\"count\">0</td><td class=\"delete\"><i class=\"icon-remove\"></i></td></tr>");
			@a_possibleAnswers.push(value.toLowerCase())	
			@a_userAnswersCount.push(0);	  	
			$("input#add-answer-value").val("")
			false
		)
		#
		# Delete answer
		#
		$('table#answers-list i').on('click', () ->
			console.log 'delete';
		)

	##
	# 
	##
	initUI: () ->
		$('body').prepend('<div id="twitch-question-ui"></div>')
		$('#twitch-question-ui').append("<p id=\"btn-start\" style=\"color:#{colorInactive}>Ask question !</p>")



$(document).ready(->
	$('form#msg').submit (e) ->
		val = $("input#test").val()
		pseudo = $("input#pseudo").val()
		$("#list").append("<li data-sender=\"#{pseudo}\">#{val}</li>")
		false

	q = new Question()
	q.initUIListener();
)

