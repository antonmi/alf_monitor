// import { DataSet, Network } from 'vis/index-network';
// function getOptions() {
//   // Return vis.js options here, like layout, physics, etc
//   // Ommited for brevity
// }
// function addNode(nodes, id, label, description, result = null) {
//   nodes.push({
//     id: id,
//     label: "<b>" + label + "</b>",
//   description: description
// })
//   return nodes
// }
// function addLink(links, id, start_id, end_id, label = null) {
//   links.push({
//     id: id,
//     from: start_id,
//     to: end_id,
//     arrows: "to",
//   physics: "false",
//   label: "<b>" + label + "</b>"
// })
//   return links
// }
// function diagramInit(data) {
//   let diagram = data
//   // Setup data
//   let nodes = []
//   diagram.components.forEach(component => {
//     nodes = addNode(nodes, component.id, component.name, component.description, component.result)
//   })
//   // Setup links
//   let links = []
//   diagram.links.forEach(link => {
//     links = addLink(links, link.id, link.start_component_id, link.end_component_id)
//   })
//   // Setup graph
//   let container = document.getElementById('diagram')
//   let graph_data = { nodes: nodes, edges: links }
//   new Network(container, graph_data, getOptions())
// }
// export default diagramInit
