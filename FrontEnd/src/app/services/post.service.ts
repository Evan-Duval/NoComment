import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class PostService {
  private apiUrl = 'http://127.0.0.1:8000/api/posts';

  constructor(private http: HttpClient) {}

  getGroupsByUser(groupId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/getByGroup/${groupId}`);
  }
}
