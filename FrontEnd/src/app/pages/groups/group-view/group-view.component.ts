import { Component, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';
import { ActivatedRoute } from '@angular/router';
import { OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { GroupService } from '../../../services/group.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-group-view',
  imports: [CommonModule],
  templateUrl: './group-view.component.html',
  styleUrl: './group-view.component.css'
})
export class GroupViewComponent implements OnInit, OnDestroy {
  groupId!: number;
  private routeSub: Subscription = new Subscription();
  groupData: any;

  posts = [
    {
      author: 'Anaïs',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque in ante quis magna faucibus tincidunt.',
      timestamp: '2 heures',
      likes: 5,
      comments: 2
    },
    {
      author: 'Émile',
      content: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
      timestamp: '4 heures',
      likes: 3,
      comments: 1
    }
  ];

  members = [
    {
      name: 'Groupe Alpha',
      image: 'https://via.placeholder.com/48',
      lastActivity: 'Il y a 1h'
    },
    {
      name: 'Groupe Beta',
      image: 'https://via.placeholder.com/48',
      lastActivity: 'Il y a 3h'
    }
  ];

  constructor(private route: ActivatedRoute, private groupService: GroupService) {}

  ngOnInit(): void {
    this.routeSub = this.route.paramMap.subscribe(params => {
      this.groupId = Number(this.route.snapshot.paramMap.get('id'));
      this.groupService.getGroupById(this.groupId).subscribe({
        next: (data) => {
          this.groupData = data;
          console.log(data)
        },
        error: (error) => {
          console.error('Erreur lors de la récupération du groupe', error);
        }
      });
    });
    console.log(this.groupId)    
  }

  joinGroup(): void {
    // Logique pour rejoindre le groupe
    console.log('Rejoindre le groupe', this.groupId);
  }

  ngOnDestroy() {
    this.routeSub.unsubscribe();
  }
}