import { NgModule } from '@angular/core';
import { ServerModule } from '@angular/platform-server';
import { AppModule } from './app.module';
import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';
import { AppComponent } from './app.component';

@NgModule({
  imports: [AppModule, ServerModule],
  bootstrap: [LoginComponent],
})
export class AppServerModule {}
