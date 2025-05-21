import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class GroupService {
  private apiUrl = 'http://127.0.0.1:8000/api/groups';

  constructor(private http: HttpClient) {}

  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('token');
    return new HttpHeaders({
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    });
  }

  getGroupsByUser(userId: number | string): Observable<any> {
    return this.http.get(`${this.apiUrl}/getUserGroups/${userId}`);
  }

  createGroup(groupData: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/create`, groupData);
  }

  getGroupById(groupId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/getGroup/${groupId}`);
  }

  getGroupMembers(groupId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/getGroupMembers/${groupId}`);
  }

  toggleFollowGroup(groupId:number, group: Array<any>): Observable<any> {
    const headers = this.getHeaders();
    return this.http.post(`${this.apiUrl}/toggleFollowGroup/${groupId}`, group, { headers });
  }
}

