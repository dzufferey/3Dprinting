//step 1: turn the faces into equations (already include the offset into the equations) and build an adjacency list for the points.
//step 2: for each point, get the equations, solve, and check that the solution is optimal/unique.

//each worker get the sets of vertices and faces (indexed), more concretely the geometry and the indices of faces and vertices to process.
//after processing the faces send back the equations
//after receiving all the equations process the vertices, send back the new vertices


importScripts('libglpk.js'); 
//importScripts('three.js'); 

addEventListener('message', function(e) {
   var geometry = e.geometry;
   var startIdx = e.start;
   var endIdx = e.end;
   var offset = e.offset;
   //(1)
   //  traverse the faces to know which ones are adjacent to the vertices we are processing
   var inBounds = function(idx) { startIdx <= idx && idx < endIdx };
   var vertexToFace = [];
   var vertexNormal = [];
   for (var i = 0; i < (endIdx - startIdx); i++) {
       vertexToFace[i] = [];
   }
   for (var i = 0; i < geometry.faces.length; i++) {
       var f = geometry.faces[i];
       if ( (inBounds(f.a) || inBounds(f.b) || inBounds(f.c) ) {
           //make an equation for the adjacent vertices
           var eq = planeEquation(geometry.vertices[faces.a], f.normal, offset);
           //store it into an easy-to-look-up place, also store the vertex normal
           if (inBounds(f.a)) {
               vertexToFace[f.a - startIdx].push(eq);
               vertexNormal[f.a - startIdx] = f.vertexNormals[0];
           }
           if (inBounds(f.b)) {
               vertexToFace[f.b - startIdx].push(eq);
               vertexNormal[f.b - startIdx] = f.vertexNormals[1];
           }
           if (inBounds(f.c)) {
               vertexToFace[f.c - startIdx].push(eq);
               vertexNormal[f.c - startIdx] = f.vertexNormals[2];
           }
       }
   }
   //(2) compute the new points
   //TODO (optional) report progress at different time intervals
   var result = [];
   for (var i = 0; i < endIdx - startIdx; i++) {
       result[i] = getIntersection(vertexToFace[i], vertexNormal[i]);
   }
   //(3)
   //  post the reply
   postMessage( {
       start: startIdx,
       end: endIdx,
       new_points: result
   });
}, false);

//about the GLPK problem:
//(is three.js using quaternion ?)
//the problem has 3 variables: x,y,z (coordinate of the intersection of the plan)
//and as many constraint as there are adjacent face
//TODO how to check that the problem is not underconstrained ?

/* equation for a plan given by 3 points (a,b,c) in euclidian space
 * compute the normal: n = (b-a) × (c-a), better: ask three.js to compute the normals
 *
 * equation for x in the plan: (x-a) · n = 0 or x·n = a·n
 * offset is applied as a′ = a - δ * n / |n| and then using a′ in the equation.
 *
 * @assume the normal is unit
 * @returns eq[0] * x + eq[1] * y + eq[2] * z = eq[3]
 */
function planeEquation(p, n, offset) {
    var eq = new Float64Array(4);
    eq[0] = n.x;
    eq[1] = n.y;
    eq[2] = n.z;
    eq[3] = (p.x + offset * n.x) * n.x +
            (p.y + offset * n.y) * n.y +
            (p.z + offset * n.z) * n.z ;
    return eq;
}

//TODO should we relax the constraints to upper bound (half-spacees)
//and have an optimization objtectif to push it close to the bound
//a potential objective function is to push as far as possible in the direction of the normal of the vertex (as given by three.js)
/**
 * @param planes arrays of planes equations
 * @param vNormal the vertex normal as a 3DVector
 */
function getIntersection(planes, vNormal) {
    var lp = MAKE_SOLVER();
    lp.set_name("planes intersection");
    lp.add_cols(3);
    lp.add_rows(planes.length);
    //variables (x,y,z) all unbounded
    lp.set_col_name(1, "x");
    lp.set_col_name(2, "y");
    lp.set_col_name(3, "z");
    lp.set_col_bnds(1, GLPK.fr, 0.0, 0.0);
    lp.set_col_bnds(2, GLPK.fr, 0.0, 0.0);
    lp.set_col_bnds(3, GLPK.fr, 0.0, 0.0);
    //constraint matrix
    var ia = new Int32Array(3 * planes.length + 1);
    var ja = new Int32Array(3 * planes.length + 1);
    var ar = new Float64Array(3 * planes.length + 1);
    for (var i = 0; i < planes.length; i++) {
        ia[3*i+1] = i+1;    ja[3*i+1] = 1;  ar[3*i+1] = planes[i][0];
        ia[3*i+2] = i+1;    ja[3*i+2] = 2;  ar[3*i+2] = planes[i][1];
        ia[3*i+3] = i+1;    ja[3*i+3] = 3;  ar[3*i+3] = planes[i][2];
        lp.set_row_bnds(i+1, GLPK.up, /*planes[i][3]*/ 0.0, planes[i][3]);
    }
    lp.load_matrix(3 * planes.length, ia, ja, ar);
    //objective: push as far a possible in the direction of the normal
    lp.set_obj_coeff(1, vNormal.x);
    lp.set_obj_coeff(2, vNormal.y);
    lp.set_obj_coeff(3, vNormal.z);
    //solving
    var solving = lp.simplex();
    if (solving == 0) {
        //var z = lp.get_obj_val();
        var res = new Float64Array[3];
        res[0] = lp.get_col_prim(1);
        res[1] = lp.get_col_prim(2);
        res[2] = lp.get_col_prim(3);
        lp.free();
        return res;
    } else {
        //TODO raise an error
    }
}
