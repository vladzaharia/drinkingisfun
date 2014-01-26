// adapted from http://www.youtube.com/watch?v=qNM0k522R7o
 
extern vec2 size;
extern int samples = 10; // pixels per axis; higher = bigger glow, worse performance
extern float quality = 2.5; // lower = smaller glow, better quality
extern float BAC;
extern float cScale;
extern float eTime;
extern bool bloomStatus;
 
 // -- normalized axis vectors. we'll use these to
//    get the angles
const vec3 cXaxis = vec3(1.0, 0.0, 0.0);
const vec3 cYaxis = vec3(0.0, 1.0, 0.0);

const float cStrength = 0.005;
// -- speed of the 'wave' effect
float sStrength = 1;

vec4 effect(vec4 colour, Image tex, vec2 tc, vec2 sc)
{

    if(BAC > 80){
        sStrength = 10;
    } else if (BAC > 50) {
        sStrength = 5;
    } else if (BAC > 30) {
        sStrength = 2;
    } else {
        sStrength = 1;
    }

    vec4 source =  Texel(tex, tc);

    if(BAC > 30){
        vec2 directionVec = normalize(tc);

        // Calculate the angle between this vertex and the x y z planes
        float xangle = dot(cXaxis, vec3(directionVec,1.0)) * 5.0;
        float yangle = dot(cYaxis, vec3(directionVec,1.0)) * 6.0;

        vec4 timeVec = vec4(tc,1.0,1.0);
        float time = eTime*sStrength;

        // -- cos & sin calculations for each of the angles
        float cosx = cos(time + xangle);
        float sinx = sin(time + xangle);
        float cosy = cos(time + yangle);
        float siny = sin(time + yangle);

        // -- multiply all the parameters to get the final
        //    vertex position
        timeVec.x += directionVec.x * cosx * sinx * cStrength;
        timeVec.y += directionVec.y * sinx * cosy * cStrength;

        vec2 coord = vec2(timeVec.x, tc.y);
        source = Texel(tex, coord);
    }

  vec4 sum = vec4(0);
  int diff = (samples - 1) / 2;
  vec2 sizeFactor = vec2(1) / size * quality;
  
  if (bloomStatus) {
    for (int x = -diff; x <= diff; x++)
    {
      for (int y = -diff; y <= diff; y++)
      {
        vec2 offset = vec2(x, y) * sizeFactor;
        sum += Texel(tex, tc + offset);
      }
    }
  }
   return (((sum / (samples * samples)) + source) * sin(cScale) * colour) + source;
}