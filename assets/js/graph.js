function initGraph() {
  window.nodes = new vis.DataSet(window.nodes);
  window.edges = new vis.DataSet(window.edges);

  // create a network
  var container = document.getElementById("graph");
  var data = {
    nodes: nodes,
    edges: edges
  };
  var options = {
    nodes: {
      color: {
        border: '#2B7CE9',
        background: '#97C2FC',
        highlight: {
          border: '#2B7CE9',
          background: '#D2E5FF'
        },
        hover: {
          border: '#2B7CE9',
          background: '#D2E5FF'
        }
      },
      font: {
        size: 18
      }
      // image: '/images/stage.png',
      // imagePadding: {
      //   left: 0,
      //   top: 0,
      //   bottom: 0,
      //   right: 0
      // },
    },
    layout: {
      randomSeed: 0,
      improvedLayout: true,
      clusterThreshold: 150,
      hierarchical: {
        enabled: true,
        // levelSeparation: 150,
        // nodeSpacing: 100,
        // treeSpacing: 200,
        // blockShifting: true,
        // edgeMinimization: true,
        // parentCentralization: true,
        direction: 'RL',        // UD, DU, LR, RL
        sortMethod: 'directed',  // hubsize, directed
        shakeTowards: 'leaves'  // roots, leaves
      }
    }
  }
  window.network = new vis.Network(container, data, options);
}


export default initGraph
