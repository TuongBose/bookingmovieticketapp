import { Component } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-home',
  standalone: false,
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent {
  constructor(private authService:AuthService, private router: Router){}

  logout(): void{
    this.authService.logout();
    this.router.navigate(['/login'])
  }
}
