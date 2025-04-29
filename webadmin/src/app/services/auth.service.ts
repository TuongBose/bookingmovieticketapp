import { HttpClient } from '@angular/common/http';
import { Inject, Injectable, PLATFORM_ID } from '@angular/core';
import { Observable } from 'rxjs';
import { UserLoginDTO } from '../dtos/user-login-dto.model';
import { User } from '../models/user.model';
import { loadavg } from 'os';
import { isPlatformBrowser } from '@angular/common';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private apiURL = 'http://localhost:8080/api/v1';

  constructor(
    private http: HttpClient,
    @Inject(PLATFORM_ID) private platformId: Object
  ) { }

  login(userLoginDTO: UserLoginDTO): Observable<User> {
    return this.http.post<User>('${this.apiURL}/users/login', userLoginDTO);
  }

  setUser(user: User): void {
    if (isPlatformBrowser(this.platformId)) {
      localStorage.setItem('user', JSON.stringify(user));
      localStorage.setItem('isLoggedIn', 'true');
    }
  }

  isLoggedIn(): boolean {
    if (isPlatformBrowser(this.platformId)) {
      return localStorage.getItem('isLoggedIn') === 'true';
    }
    return false;
  }

  getUser(): User | null {
    if (isPlatformBrowser(this.platformId)) {
      const user = localStorage.getItem('user')
      return user ? JSON.parse(user) : null;
    }
    return null;
  }

  logout(): void {
    if (isPlatformBrowser(this.platformId)) {
      localStorage.removeItem('user');
      localStorage.removeItem('isLoggedIn')
    }
  }
}
