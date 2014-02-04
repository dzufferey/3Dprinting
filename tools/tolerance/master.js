//assumes three.js is loaded

//loading and saving files:
// STLLoader have some support to load
// another way is https://thiscouldbebetter.wordpress.com/2012/12/18/loading-editing-and-saving-a-text-file-in-html5-using-javascrip/
// there was some STL writer somewhere ...

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
            for (var i = evt.start; i < evt.end; i++) {
                var new_v = evt.new_points[i - evt.start];
                if (new_v == undefined) {
                    //TODO report error
                } else {
                    mesh.geometry.vertices[i] = new THREE.Vector3( new_v[0], new_v[1], new_v[2]);
                }
            }
            verticesProcessed = verticesProcessed + evt.end - evt.start;
            if (verticesProcessed == mesh.geometry.vertices.length) {
                finalize();
            } else {
                //TODO report progess
            }
        },
        onError: function(err) {
            document.getElementById('error').textContent = [
                'ERROR: Line ', e.lineno, ' in ', e.filename, ': ', e.message
            ].join('');
        },
        finalize: function() {
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

