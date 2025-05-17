import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class LikeService {
  private apiUrl = 'http://127.0.0.1:8000/api/likes';
  
  constructor(private http: HttpClient) {}

  getLikesByPost(postId: number, userId?: number): Observable<any> {
  let params: any = {};
  if (userId !== undefined) {
    params.userId = userId;
  }
  return this.http.get(`${this.apiUrl}/getLikesByPost/${postId}`, { params });
}
  
  likePost(postId: number, userId: number): Observable<any> {
    return this.http.post(`${this.apiUrl}/likePost`, { postId, userId });
  }

  unlikePost(postId: number, userId: number): Observable<any> {
    return this.http.post(`${this.apiUrl}/unlikePost`, { postId, userId });
  }

}
