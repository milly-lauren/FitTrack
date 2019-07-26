import React, { useState }from 'react';
import ReactMapGL from 'react-map-gl';
import MapGL, {GeolocateControl} from 'react-map-gl'
// For the current.. this sets the poistion on the screen for them.
const geolocateStyle = {
  position: 'absolute',
  top: 0,
  left: 0,
  margin: 10
};

// For this export it will set the size of the map and what coordinates it will spawn the map on
  export default function App() {
    const [viewport, setViewport] = useState({
      latitude: 28.6024274,
      longitude: -81.2000599,
      width: "100vw",
      height: "100vh",
      zoom: 10 ,
    });
  
    
    
  return (
    <div>
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

      
      
    </div>
  );
}