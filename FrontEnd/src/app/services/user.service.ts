import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  private apiUrl = 'http://127.0.0.1:8000/api/auth';

  constructor(private http: HttpClient) {}

  getUserByToken(token: string): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/user/${token}`);
  }
}