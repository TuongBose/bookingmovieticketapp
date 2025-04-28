import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { UserLoginDTO } from '../dtos/user-login-dto.model';
import { User } from '../models/user.model';
import { loadavg } from 'os';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private apiURL = 'http://localhost:8080/api/v1/login';

  constructor(private http: HttpClient) {}

  login(userLoginDTO: UserLoginDTO): Observable<User> {
    return this.http.post<User>('${this.apiURL}/users/login', userLoginDTO);
  }

  setUser(user: User): void {
    localStorage.setItem('user', JSON.stringify(user));
    localStorage.setItem('isLoggedIn', 'true');
  }
  
  isLoggedIn(): boolean{
    return localStorage.getItem('isLoggedIn')=== 'true';
  }

  getUser(): User|null{
    const user = localStorage.getItem('user')
    return user?JSON.parse(user):null;
  }

  logout():void{
    localStorage.removeItem('user');
    localStorage.removeItem('isLoggedIn')
  }
}
