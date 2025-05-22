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

  getLikesByComment(commentId: number, userId?: number): Observable<any> {
    let params: any = {};
    if (userId !== undefined) {
      params.userId = userId;
    }
    return this.http.get(`${this.apiUrl}/getLikesByComment/${commentId}`, { params });
  }

  likePost(postId: number, userId: number): Observable<any> {
    let params: any = {};
    if (userId !== undefined) {
      params.id_user = userId;
      params.id_post = postId;
    }
    return this.http.post(`${this.apiUrl}/addLike`, {}, { params });
  }

  likeComment(commentId: number, userId: number): Observable<any> {
    let params: any = {};
    if (userId !== undefined) {
      params.id_user = userId;
      params.id_comment = commentId;
    }
    return this.http.post(`${this.apiUrl}/addLike`, {}, { params });
  }

  unlikePost(postId: number, userId: number): Observable<any> {
    let params: any = {};
    if (userId !== undefined) {
      params.id_user = userId;
    }
    return this.http.delete(`${this.apiUrl}/removePostLike/${postId}`, { params });
  }

  unLikeComment(commentId: number, userId: number): Observable<any> {
    let params: any = {};
    if (userId !== undefined) {
      params.id_user = userId;
    }
    return this.http.delete(`${this.apiUrl}/removeCommentLike/${commentId}`, { params });
  }

}
