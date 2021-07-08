<template>
  <div class="about">
    <h1>
      About Me
    </h1>
    <b-row>
      <b-card  img-src="@/assets/me.jpg" img-alt="linkedin image" img-left class="mb-2 aboutCard" img-height= 300em>
          <b-card-text>
            My name is Ronan Lewsley. I am currently, (as of 06/07/21) at the end of my 3rd year at Ulster University, of which I spent as a full stack web developer at Flax & Teal Ltd.
            This has allowed me to gain the necessary experience to build and deploy this full stack Site. 
          </b-card-text>
      </b-card>
      <b-card title="Main Technical Abilities & Skills" class="mb-2 aboutCard" >
          <b-list-group class="bList1">
            <b-list-group-item>Vue JS</b-list-group-item>
            <b-list-group-item>Laravel</b-list-group-item>
            <b-list-group-item>Python</b-list-group-item>
            <b-list-group-item>Kubernetes</b-list-group-item>
            <b-list-group-item>Docker</b-list-group-item>
          </b-list-group>
      </b-card>
    </b-row>
      
  </div>
</template>

<style>


.aboutCard {
    border-radius: 6em;
    padding-top: 1em;

    }



.bList1{
  width: 70%;
  margin-left: auto;
  margin-right: auto;
  border-radius: 2em;
  margin-top: 2em;

}

.card{
  width: 45vw;
  margin-left: auto;
  margin-right: auto;
  margin-top: 5em;
  background-color: #2b475e;
  color: #42b983;
}


.card-img-left {
  border-radius: 6em;
  padding: 2em;
  
}

.card-body{
  margin-top: 3em;
  
}

.list-group-item{
  background-color: #2b475e;
  border: 10px solid black;
  color: aliceblue;
}
</style>
