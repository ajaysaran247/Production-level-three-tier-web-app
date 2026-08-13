import React,{useEffect,useState} from "react";
import API from "./api";

function App(){

const [data,setData]=useState({});

useEffect(()=>{

fetch(API)
.then(res=>res.json())
.then(result=>setData(result));

},[]);

return(

<div>

<h1>AWS Three Tier Application</h1>

<h2>{data.message}</h2>

<p>{data.status}</p>

</div>

);

}

export default App;
