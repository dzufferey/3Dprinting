//assumes three.js is loaded

//Is there a way of getting the number of CPU available ? no, but can try https://github.com/oftn/core-estimator/
function addTolerance_dispatch(mesh, tolerance, nbWorkers) {
    //TODO some sanity checks ?
    //(1) use three.js to compute the normals: faces + vertices
    var geometry = mesh.geometry;
    geometry.dynamic = true;
    geometry.computeFaceNormals();
    geometry.computeVertexNormals();
    //(2) split the work into batches:
    //-do we have an adjacency function: vertex -> set faces (unless we are sending large objects, it should be ok)
    //-partition the vertices
    var nbVertices = geometry.vertices.length;
    var batchSize = Math.ceil(nbVertices / nbWorkers);
    var startIdx = 0;
    //creates an object/closure for the events sent back by the workers
    var job = {
        mesh: mesh,
        verticesProcessed: 0
        onMessage: function(evt) {
            //TODO
        },
        onError: function(err) {
            document.getElementById('error').textContent = [
                'ERROR: Line ', e.lineno, ' in ', e.filename, ': ', e.message
            ].join('');
        },
        finalize: function() {
            //TODO
            geometry.verticesNeedUpdate()
            //TODO tell someone it has been updated ?!
        }
    };
    //-send the mesh + vertices to process to the workers
    for (var i = 0; i < nbWorkers; i++) {
        var endIdx = Math.min(nbVertices, startIdx + batchSize);
        var msg = {
          geometry: geometry,
          start: startIdx,
          end: endIdx,
          offset: offset
        };
        var worker = new Worker('worker.js');
        worker.addEventListener('message', job.onMessage, false);
        worker.addEventListener('error', job.onError, false);
        worker.postMessage(msg); // Start worker without a message.
        startIdx = endIdx;
    }
}

