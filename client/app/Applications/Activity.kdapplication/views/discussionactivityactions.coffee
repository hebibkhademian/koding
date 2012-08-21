class DiscussionActivityActionsView extends ActivityActionsView
  constructor :->
    super

    activity = @getData()

    @replyLink = new ActivityActionLink
      partial  : "Join this discussion"


  viewAppended:->

    @setClass "activity-actions"
    @setTemplate @pistachio()
    @template.update()
    @attachListeners()
    @loader.hide()

  attachListeners:->

    activity    = @getData()
    commentList = @getDelegate()

    commentList.on "BackgroundActivityStarted", => @loader.show()
    commentList.on "BackgroundActivityFinished", => @loader.hide()
    @likeLink.registerListener
      KDEventTypes  : "Click"
      listener      : @
      callback      : =>
        if KD.isLoggedIn()
          activity.like (err)=>
            if err
              log "Something went wrong while like:", err
              new KDNotificationView
                title     : "You already liked this!"
                duration  : 1300

    @replyLink.registerListener
      KDEventTypes  : "Click"
      listener      : @
      callback      : (pubInst, event) ->
        commentList.propagateEvent KDEventType : "CommentLinkReceivedClick", event



  pistachio:->

    """
    {{> @loader}}
    {{> @replyLink}}{{> @commentCount}} ·
    <span class='optional'>
    {{> @shareLink}} ·
    </span>
    {{> @likeLink}}{{> @likeCount}}
    """