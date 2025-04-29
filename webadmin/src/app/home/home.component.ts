import { Component, Inject, PLATFORM_ID } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { Router } from '@angular/router';
import { platformBrowser } from '@angular/platform-browser';
import { isPlatformBrowser } from '@angular/common';

@Component({
  selector: 'app-home',
  standalone: false,
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent {
  constructor(
    private authService: AuthService,
    private router: Router,
    @Inject(PLATFORM_ID) private platformId: Object
  ) { }

  logout(): void {
    this.authService.logout();
    if (isPlatformBrowser(this.platformId)) {
      this.router.navigate(['/login'])
    }
  }
}
