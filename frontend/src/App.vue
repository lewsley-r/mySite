<template>
  <div id="app">
    <div id="nav">
    <b-nav tabs class="navbar">
      <b-navbar-brand to="/">
        <img src="@/assets/RL-Logo.png" class="d-inline-block align-top" alt="RL Logo" height="150em">
      </b-navbar-brand>
      <b-nav-item to="/about" >About</b-nav-item>
      <b-nav-item href="https://github.com/lewsley-r">
        <b-icon icon="github" variant="warning"></b-icon>
        GitHub
      </b-nav-item>
      <b-nav-item href="https://www.linkedin.com/in/ronan-lewsley-9b1bbb199/">
        <b-icon icon="linkedin" variant="warning"></b-icon>
        LinkedIn
      </b-nav-item>  
      <b-nav-text style="align: right">
        <b-icon icon="envelope-fill" variant="warning"></b-icon>
        lewsley-r@ulster.ac.uk
      </b-nav-text>
    </b-nav>
    </div>
    <router-view/>
  </div>
</template>

<style lang="scss">

#html{
  height: 100%;
  width: 100%;
  overflow: hidden;
}

#app {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #42b983;
  background-image: url('assets/cardPostPic.jpg');
  background-size: cover;
  height: 100vh;
  width: 100vw;
  padding-top: -1vh;
}

#nav {
  padding: 30px;

  a {
    font-weight: bold;
    color: #42b983;

    &.router-link-exact-active {
      color: #42b983;
    }
  }
  .navbar {
    margin-top: -4vh;
    width: 100vw;
    left: -2vw;
    background-color: #2b475e;
    justify-content: space-between;

  }

  .navbar-text{
    color: #42b983;
    text-align: right;
    
  }
  
}
</style>
