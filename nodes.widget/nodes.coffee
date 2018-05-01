# Execute the shell command.
command: "kubernetes.widget/nodes.widget/nodes.sh"

# Set the refresh frequency (milliseconds).
refreshFrequency: 5000

# Render the output.
render: (output) -> """
  <table id='nodes'>
    <tr class='node node-header'>
      <th>Name</th>
      <th>Status</th>
      <th>Role</th>
      <th>Version</th>
    </tr>
  </table>
"""

# Update the rendered output.
update: (output, domEl) -> 
  dom = $(domEl)

  # # Parse the JSON created by the shell script.
  data = JSON.parse(output)

  html = ""
  # # Loop through the pods in the JSON.
  for item in data.items
    # status_class_colour = if (item.status.phase is "Running") then '' else 'red'
    ready = item.status.conditions[item.status.conditions.length-1].type;
    uptime = new Date(item.metadata.creationTimestamp)
    age = 1

    html +="
      <tr class='node node-item'>
        <td>#{item.metadata.name}</td>
        <td>#{ready}</td>
        <td>#{item.metadata.labels['kubernetes.io/role']}</td>
        <td>#{item.status.nodeInfo.kubeletVersion}</td>
      </tr>"

  # Set output.
  $("#nodes .node-item").remove()
  $("#nodes .node-header").after(html)

# CSS Style
style: """
  margin:0
  padding:0px
  left:30px
  top: 270px
  width:auto
  background:rgba(#000, .5)
  border:1px solid rgba(#000, .25)
  border-radius:5px
  
  .node
    text-align: left
    padding: 20px
    font-size: 10pt
    font-weight: bold
    font: 10px arial, sans-serif;

  .node .red
    color: rgba(#f00,0.75)

  .node td
    color: rgba(#A9A9A9)
    padding: 1px 5px
  
  .node th
    color: rgba(#fff)
    padding: 1px 5px
"""
