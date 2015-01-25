# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$('#journal_entry_entry_date_3i').change ->
  year = $('#journal_entry_entry_date_1i').val()
  month = $('#journal_entry_entry_date_2i').val()
  weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  day = $(this).val()
  date = new Date(year, month - 1,day)
  $(this).next('.help-block').html(weekdays[date.getDay()])

display_saved = (that) ->
  # put a green border around the text area
  $(that).css('border-color', 'green')
  # if saved exists, show and fade it, otherwise, create it, then fade it
  if $("#saved").length == 0
    s = '<div class="alert" id="saved"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>Saved</strong></div>'
    $(".span12").first().prepend(s)
    $("#saved").fadeOut(2000)
  else
    $("#saved").show().fadeOut(2000)

save_form = (that) ->
  display_saved that
  $form = $(that).parents('form:first');
  # first find the action of the form
  #match = /^(\/\w+\/\w+\/\w+|\/\w+)\/(\w+)$/.exec($form.attr("action"))
  match = /((\w+)\/(\w+)|(\w+))\/(\d+)/.exec($form.attr("action"));
  id = match.pop() if match
  if id # journal_entries#update
    # this must be a "put" to route correctly . . .
    $.post('/journal_entries/form_update/' + id, $form.serialize(), null, "json")
  else # have a brand new form, add an id (journal_entries#create, then make it so it does journal_entries#update)
    # do regular post to add, then change the form to look like an edit form
    # this means updating two things: (1) an id added to the input field (2) the put method input
    $.post('/journal_entries/', $form.serialize(), (data) ->
      id =  data.id
      $form.attr "action", '/journal_entries/' + id # change form to include id
      input_method = $('input[name="_method"]')
      unless input_method.length > 0 # add the put field if needed
        $form.find('div').first().append('<input name="_method" type="hidden" value="put">')
    , 'json')


$("#update-button").click ->
  save_form this

#if  $("#journal_entry_form").length > 0
#  $("#journal_entry_description").live "blur", ->
#    save_form this
#
#  $("#journal_entry_to_do").live "blur", ->
#    save_form this

if $("#journal_entries_report").length > 0
  months = $("#journal_entries_report").data('months')
  $.get("/journal_entries/data/" + months, (data) ->
    Morris.Line
      element: 'journal_entries_report'
      data: data
      xkey: 'index'
      ykeys: ['count'] # , 'purity', 'chrissy', 'devotional']
      labels: ['frequency'] #, 'purity', 'chrissy', 'devotional']
  )

if $("#monthly_report").length > 0
  month = $("#monthly_report").data('month-string')
  #monthly_report{data: { month_string: @month_string }}
  console.log "about to request: " + month
  #  month = "Nov-13" if month == "undefined"
  $.get("/journal_entries/month_data/" + month, (data) ->
    Morris.Line
      element: 'monthly_report'
      data: data
      xkey: 'entry_date'
      ykeys: ['purity', 'chrissy', 'devotional', 'fitness']
      labels: ['purity', 'chrissy', 'devotional', 'fitness']
  )

$("#flossed").click ->
  console.log "flossed"
  $(".calendar_report.flossed").toggleClass "hide"

$("#discipline").click ->
  $(".calendar_report.discipline").toggleClass "hide"

$("#sick").click ->
  $(".calendar_report.sick").toggleClass "hide"

$("#workout").click ->
  $(".calendar_report.workout").toggleClass "hide"

$("#problem_attempted").click ->
  $(".calendar_report.problem_attempted").toggleClass "hide"




