function onload(saved_data)
  broadcastToAll("Welcome to the Woodland.")



  Wait.frames(
    function()
      getObjectFromGUID("bab7e1").call("startingReset")

    end,
    20
  )
end