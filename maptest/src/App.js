import React, { useState }from 'react';
import ReactMapGL from 'react-map-gl';
import MapGL, {GeolocateControl} from 'react-map-gl';
import mapboxgl from 'mapbox-gl/dist/mapbox-gl';
// For the current.. this sets the poistion on the screen for them.

const geolocateStyle = {
  position: 'absolute',
  top: 0,
  left: 0,
  margin: 10
};

mapboxgl.accessToken = 'pk.eyJ1IjoidGd1ZXJyMTIiLCJhIjoiY2p5Y2J0YXk5MGhodjNtcGViMmtkNnN0YiJ9.y0hb7dOaAeimxUfx93rcyA'; // replace this with your access token
    var map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/tguerr12/cjyd6kex42rps1cmomr9a7sz0', // replace this with your style URL
      center: [-81.2000599,28.6024274],
      zoom: 10.7
    });
    map.addControl(new mapboxgl.GeolocateControl({
      positionOptions: {
      enableHighAccuracy: true
      },
      trackUserLocation: true
      }));
    
    map.on('click', function(e) {
    var features = map.queryRenderedFeatures(e.point, {
    layers: ['orlando-running-spots'] // replace this with the name of the layer
  });

  if (!features.length) {
    return;
  }

  var feature = features[0];

  var popup = new mapboxgl.Popup({ offset: [0, -15] })
    .setLngLat(feature.geometry.coordinates)
    .setHTML('<h3>' + feature.properties.title + '</h3><p>' + feature.properties.description + '</p>')
    .addTo(map);
});


//
// For this export it will set the size of the map and what coordinates it will spawn the map on
  export default function App() {
    const [viewport, setViewport] = useState({
      latitude: 28.6024274,
      longitude: -81.2000599,
      width: "100vw",
      height: "100vh",
      zoom: 10,
    });

    
  return (
      <ReactMapGL 
        {...viewport} 
        mapboxApiAccessToken='pk.eyJ1IjoidGd1ZXJyMTIiLCJhIjoiY2p5Y2J0YXk5MGhodjNtcGViMmtkNnN0YiJ9.y0hb7dOaAeimxUfx93rcyA'
        mapStyle="mapbox://styles/tguerr12/cjyd6kex42rps1cmomr9a7sz0"
        onViewportChange={viewport => {
          setViewport(viewport);
        }}
      >
        <GeolocateControl
          style={geolocateStyle}
          positionOptions={{enableHighAccuracy: true}}
          trackUserLocation={true}
        />
        

      </ReactMapGL>
  
  );
}